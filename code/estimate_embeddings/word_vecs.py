import warnings, os
warnings.filterwarnings('ignore')
import utils
import gensim
from gensim.models import Word2Vec, KeyedVectors

class WordVectors(object):
    def __init__(self, combined_data_path, model_hparams, output, model_id):
        self.combined_data_path = combined_data_path # one txt file
        self.model_hparams = model_hparams
        self.output = output
        self.model_id = model_id

    def make_w2v_model(self):
        '''
        Constructs word2vec model and saves the model binary
        '''

        sentences = gensim.models.word2vec.LineSentence(self.combined_data_path)

        gen_model = gensim.models.Word2Vec(sentences, size=self.model_hparams["size"], window=self.model_hparams["window"],\
                                            min_count=self.model_hparams["min_count"], workers=self.model_hparams["workers"],\
                                            sg=self.model_hparams["sg"], hs=self.model_hparams["hs"], negative=self.model_hparams["negative"],\
                                            iter=self.model_hparams["epochs"])

        
        #out_file = self.combined_data_path.split('/')[-1][:-4] + '.bin'
        out_file = "model_" + str(self.model_id) + '.bin'
        utils.construct_output_dir(self.output["output_model_dir"])
        gen_model.wv.save_word2vec_format(self.output["output_model_dir"] + out_file, binary=True)
        return

    def make_bert_model(self, time_series, collection):
        pass

    def load_model(self, file):
        '''
        Loads in the word2vec or BERT model
        '''
        if self.model_hparams["name"] == 'word2vec':
            vector_model = gensim.models.KeyedVectors.load_word2vec_format(file, binary=True)
        else:
            vector_model = KeyedVectors.load(file)
        return vector_model
